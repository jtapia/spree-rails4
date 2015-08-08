module Spree
  module Api
    module V1
      class DashboardController < Spree::Api::BaseController

        before_filter :dump_headers
        after_filter :dump_response

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
              where(created_at: ((Date.today-1.day).beginning_of_day..Date.today.end_of_day)).sum(:total)
          when :order
            Spree::Order.
              where(created_at: ((Date.today-1.day).beginning_of_day..Date.today.end_of_day)).count
          else
            Spree.send("#{type}_class").
              where(created_at: ((Date.today-1.day).beginning_of_day..Date.today.end_of_day)).count
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
              where(created_at: ((Date.today-7.day).beginning_of_day..Date.today.end_of_day)).count
          when :order
            Spree::Order.
              where(created_at: ((Date.today-7.day).beginning_of_day..Date.today.end_of_day)).count
          else
            Spree.send("#{type}_class").
              where(created_at: ((Date.today-7.day).beginning_of_day..Date.today.end_of_day)).count
          end

          {
            value: value,
            name: 'Last Week'
          }
        end

        def total(type)
          value = case type
          when :revenue
            Spree::Order.sum(:total)
          when :order
            Spree::Order.sum(:total)
          else
            Spree.send("#{type}_class").count
          end

          {
            value: value,
            name: 'Total'
          }
        end

        def dump_headers
          if ENV['DUMP_HEADERS'] == 'yes'
            Rails.logger.info(request.headers.inspect)
          end
        end

        def dump_response
          if ENV['DUMP_RESPONSE_HEADERS'] == 'yes'
            Rails.logger.info(response.headers.inspect)
          end
        end


      end
    end
  end
end