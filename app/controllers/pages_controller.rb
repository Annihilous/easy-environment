require 'x12'

class PagesController < ApplicationController
  def index
    parser = X12::Parser.new('misc/997.xml')

    m997='ST*997*2878~AK1*HS*293328532~AK2*270*307272179~'\
'AK3*NM1*8*L1010_0*8~AK4*0:0*66*1~AK4*0:1*66*1~AK4*0:2*'\
'66*1~AK3*NM1*8*L1010_1*8~AK4*1:0*66*1~AK4*1:1*66*1~AK3*'\
'NM1*8*L1010_2*8~AK4*2:0*66*1~AK5*R*5~AK9*R*1*1*0~SE*8*2878~'

    @parser = parser.parse('997', m997)

    
  end
end
