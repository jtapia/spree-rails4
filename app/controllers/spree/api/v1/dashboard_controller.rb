module Spree
  module Api
    module V1
      class DashboardController < Spree::Api::BaseController

        def index
          result = {
            users: [ last_day(:user), weekly(:user), total(:user) ],
            orders: [ last_day(:order), weekly(:order), total(:order) ],
            revenue: [ last_day(:revenue), weekly(:revenue), total(:revenue)]
          }

          render json: result, status: :ok
        end

        private

        def last_day(type)
          value = case type
          when :revenue
            Spree::Order.
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).sum(:total)
          when :order
            Spree::Order.
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).count
          else
            Spree.send("#{type}_class").
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).count
          end

          {
            value: value,
            name: 'Last Day'
          }
        end

        def weekly(type)
          value = case type
          when :revenue
            Spree::Order.
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).sum(:total)
          when :order
            Spree::Order.
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).count
          else
            Spree.send("#{type}_class").
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).count
          end

          {
            value: value,
            name: 'Last Week'
          }
        end

        def total(type)
          value = case type
          when :revenue
            Spree::Order.
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).sum(:total)
          when :order
            Spree::Order.
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).count
          else
            Spree.send("#{type}_class").
              where(created_at: Date.today.beginning_of_day..((Date.today-1.day).end_of_day)).count
          end

          {
            value: value,
            name: 'Total'
          }
        end

      end
    end
  end
end