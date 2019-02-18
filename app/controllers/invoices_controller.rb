require "stupidedi"

class InvoicesController < ApplicationController
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]

  def index
    @invoices = Invoice.all
  end

  def show
    config = Stupidedi::Config.contrib
    parser = Stupidedi::Builder::StateMachine.build(config)

    hippa_file_name = "1-good-X221-HP835.txt"
    gem_830_file = '1-good-PO830.txt'
    invoice_file = 'edi-810.txt'

    file_name = invoice_file

    input  = File.open("app/assets/files/#{file_name}", :encoding => "ISO-8859-1")

    # Reader.build accepts IO (File), String, and DelegateInput
    parser, result = parser.read(Stupidedi::Reader.build(input))

    # Report fatal tokenizer failures
    if result.fatal?
      result.explain{|reason| raise reason + " at #{result.position.inspect}" }
    end

    # Helper function: fetch an element from the current segment
    def el(m, *ns, &block)
      puts 'starting method'
      if Stupidedi::Either === m
        m.tap{|m| el(m, *ns, &block) }
      else
        yield(*ns.map{|n| m.elementn(n).map(&:value).fetch })
      end
    end

    # # Working gem hippa and contrib examples
    parser.first
      .flatmap{|m| m.find(:GS) }
      .flatmap{|m| m.find(:ST) }
      .tap do |m|
        el(m.find(:N1, "MI"), 2){|e| @print_result = "N1 MI: #{e}" }
      end

    # parser.first
    #   .flatmap{|m| m.find(:GS) }
    #   .flatmap{|m| m.find(:ST) }
    #   .tap do |m|
    #     el(m.find(:N1, "PR"), 2){|e| puts "Payer: #{e}" }
    #     el(m.find(:N1, "PE"), 2){|e| puts "Payee: #{e}" }
    #   end
    #   .flatmap{|m| m.find(:LX) }
    #   .flatmap{|m| m.find(:CLP) }
    #   .flatmap{|m| m.find(:NM1, "QC") }
    #   .tap{|m| el(m, 3, 4){|l,f| puts "Patient: #{l}, #{f}" }}
  end

  def new
    @invoice = Invoice.new
  end

  def edit
  end

  def create
    @invoice = Invoice.new(invoice_params)

    respond_to do |format|
      if @invoice.save
        format.html { redirect_to @invoice, notice: 'Invoice was successfully created.' }
        format.json { render :show, status: :created, location: @invoice }
      else
        format.html { render :new }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @invoice.update(invoice_params)
        format.html { redirect_to @invoice, notice: 'Invoice was successfully updated.' }
        format.json { render :show, status: :ok, location: @invoice }
      else
        format.html { render :edit }
        format.json { render json: @invoice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @invoice.destroy
    respond_to do |format|
      format.html { redirect_to invoices_url, notice: 'Invoice was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def invoice_params
    params.require(:invoice).permit(:edi_source, :project_id, :po_number, :issued_at, :total_cost_in_dollars)
  end
end
