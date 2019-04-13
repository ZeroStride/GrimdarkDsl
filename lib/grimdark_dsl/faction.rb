# frozen_string_literal: true

require 'grimdark_dsl/model'

module GrimdarkDsl
  #
  # Kill Team faction
  #
  module Faction
    class << self
      def included(klass)
        klass.extend(ClassMethods)
        klass.include(InstanceMethods)

        @all ||= []
        @all << klass
      end
    end

    #
    # Common class methods
    #
    module ClassMethods
      def model(model_type, &block)
        model = Model.new(model_type)
        model.instance_eval(&block)
        @models ||= {}
        @models[model_type] = model
        puts model.inspect
      end
    end

    #
    # Common instance methods
    #
    module InstanceMethods
    end
  end
end
