class Invoice < ApplicationRecord
  include PellaEdiParser

  def pella_edi_invoice
    PellaInvoice.new(edi_string_multiline)
  end

  def pella_edi_total_cost_in_dollars
    pella_edi_invoice.total_cost_in_dollars
  end

  def pella_edi_invoice_issued_at
    pella_edi_invoice.invoice_issued_at
  end

  def pella_edi_purchase_order_id
    pella_edi_invoice.purchase_order_id
  end

  def pella_edi_project_id
    pella_edi_invoice.project_id
  end


  def edi_thing_to_use
    File.open(edi_source_file)
  end

  def edi_810
    Rails.root.join("app/assets/files/edi-810.txt")
  end

  def edi_txt_file
    Rails.root.join("app/assets/files/sample-invoice.txt")
  end

  def edi_source_file
    Rails.root.join("app/assets/files/sample-invoice.edi")
  end

  def edi_string
    "ISA*00*          *00*          *01*005278502      *ZZ*SPSPOWER   *181023*0642*^*00403*000002276*0*P*~ GS*IN*005278502*SPSPOWER*20181023*0642*2276*X*004030 ST*810*0004 BIG*20181022*17142963*20181003*092-92032815 REF*IA*45570 N1*ST*Power Home Remodeling - 00092*92*092 N3*00092 POWER HOME REMODELING N4*RENO*PA*16343*US ITD*08*3*1*20181106*15*20181121*30*22758****1% 15, Net 30 DTM*011*20181022 FOB*PP IT1*1*4*EA*729.42**SK*EMENT,ARCHITECT SERIES,00-CURR PID*F****R UNIT IT1*2*5*EA*629.56**SK*EMENT,ARCHITECT SERIES,00-CURR PID*F****R UNIT IT1*3*1*EA*661.09**SK*EMENT,ARCHITECT SERIES,00-CURR PID*F****R UNIT IT1*4*7*EA*2290.25**SK*LUE ADD MULTI ROW-COL COMB PID*F****,COMBINATIONS,VALUE ADD MULTI ROW-COL COMB IT1*5*1*EA*0**SK*UP PAINT CUSTOM,ACC PID*F****,0CAW0000,TOUCH UP PAINT CUSTOM,ACC TDS*2275832*2275832 CAD*****COMPANY CARRIER CTT*5*18 SE*23*0004 GE*1*2276 IEA*1*000002276"
  end

  def print_edi(parser)
    parser.first
      .flatmap{|m| m.find(:GS) }
      .flatmap{|m| m.find(:ST) }
  end

  def edi_string_multiline
    """
      ISA*00*          *00*          *01*005278502      *ZZ*SPSPOWER   *181023*0642*^*00403*000002276*0*P*!~
      GS*IN*005278502*SPSPOWER*20181023*0642*2276*X*004030~
      ST*810*0004~
      BIG*20181022*17142963*20181003*092-92032815~
      REF*IA*45570~
      N1*ST*Power Home Remodeling - 00092*92*092~
      N3*00092 POWER HOME REMODELING~
      N4*RENO*PA*16343*US~
      ITD*08*3*1*20181106*15*20181121*30*22758****1% 15, Net 30~
      DTM*011*20181022~
      FOB*PP~
      IT1*1*4*EA*729.42**SK*EMENT,ARCHITECT SERIES,00-CURR~
      PID*F****R UNIT~
      IT1*2*5*EA*629.56**SK*EMENT,ARCHITECT SERIES,00-CURR~
      PID*F****R UNIT~
      IT1*3*1*EA*661.09**SK*EMENT,ARCHITECT SERIES,00-CURR~
      PID*F****R UNIT~
      IT1*4*7*EA*2290.25**SK*LUE ADD MULTI ROW-COL COMB~
      PID*F****,COMBINATIONS,VALUE ADD MULTI ROW-COL COMB~
      IT1*5*1*EA*0**SK*UP PAINT CUSTOM,ACC~
      PID*F****,0CAW0000,TOUCH UP PAINT CUSTOM,ACC~
      TDS*2275832*2275832~
      CAD*****COMPANY CARRIER~
      CTT*5*18~
      SE*23*0004~
      GE*1*2276~
      IEA*1*000002276~
    """
  end

  def other_string
    """
ISA*00*          *00*          *01*005278502      *ZZ*SPSPOWER   *181023*0642*^*00403*000002276*0*P*~
GS*IN*005278502*SPSPOWER*20181023*0642*2276*X*004030
ST*810*0004
BIG*20181022*17142963*20181003*092-92032815
REF*IA*45570
N1*ST*Power Home Remodeling - 00092*92*092
N3*00092 POWER HOME REMODELING
N4*RENO*PA*16343*US
ITD*08*3*1*20181106*15*20181121*30*22758****1% 15, Net 30
DTM*011*20181022
FOB*PP
IT1*1*4*EA*729.42**SK*EMENT,ARCHITECT SERIES,00-CURR
PID*F****R UNIT
IT1*2*5*EA*629.56**SK*EMENT,ARCHITECT SERIES,00-CURR
PID*F****R UNIT
IT1*3*1*EA*661.09**SK*EMENT,ARCHITECT SERIES,00-CURR
PID*F****R UNIT
IT1*4*7*EA*2290.25**SK*LUE ADD MULTI ROW-COL COMB
PID*F****,COMBINATIONS,VALUE ADD MULTI ROW-COL COMB
IT1*5*1*EA*0**SK*UP PAINT CUSTOM,ACC
PID*F****,0CAW0000,TOUCH UP PAINT CUSTOM,ACC
TDS*2275832*2275832
CAD*****COMPANY CARRIER
CTT*5*18
SE*23*0004
GE*1*2276
IEA*1*000002276

    """
  end
end
