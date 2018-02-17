require "awesome_print"
require "csv"
require_relative "order"
require_relative "customer"

ONLINEORDERS = "support/online_orders.csv"

module Grocery
  class OnlineOrder < Grocery::Order
    attr_reader :id, :products, :customer_id, :status

    def initialize(id, products, customer_id, status)
      super(id, products)
      @customer_id = customer_id
      @status = status
      @shipping_fee = 10
    end

    # Modify total method to include shipping fee
    def total
     return super + @shipping_fee
    end



    # return an array of OnlineOrder s
    def self.all
      online_orders = []
      CSV.read(ONLINEORDERS, "r").each do |online_order|
        id = online_order[0].to_i
        orders = online_order[1].split(%r{;\s*})
        # To put address info together
        order_hash = {}
        orders.each do |order|
          pair = order.split(%r{:\s*})
          order_hash[pair[0]] = pair[1]
        end
        products = order_hash
        customer_id = online_order[2].to_i
        status = online_order[3]
        online_orders << OnlineOrder.new(id, products, customer_id, status)
      end
      return online_orders
    end # self.all method ends

  end # class OnlineOrder ends

end # module Grocery ends

  # ap OnlineOrder.all

  # Customer.find(OnlineOrder.customer_id)
