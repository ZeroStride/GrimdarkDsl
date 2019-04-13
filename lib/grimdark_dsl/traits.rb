# frozen_string_literal: true

module GrimdarkDsl
  #
  # DSL for defining and copying around the traits for models
  #
  module Traits
    class << self
      def included(klass)
        klass.extend(ClassMethods)
        klass.include(InstanceMethods)
      end
    end

    #
    # Common class methods
    #
    module ClassMethods
      def traits(*attrs)
        @traits ||= []
        @traits += attrs
        attr_accessor(*attrs)
        @traits
      end

      def inherited(klass)
        (%w[traits allow_nil validate_as] + traits).each do |trait|
          ivar = "@#{trait}"
          klass.instance_variable_set(
            ivar,
            instance_variable_get(ivar)
          )
        end
      end

      def allow_nil(*attrs)
        @allow_nil ||= []
        @allow_nil.push(*attrs)
      end

      def validate_as(attr, *types)
        types = [types] unless types.is_a? Array
        @validate_as ||= {}
        @validate_as[attr] = types
      end
    end

    #
    # Common instance methods
    #
    module InstanceMethods
      def copy_traits(other)
        (%w[traits allow_nil validate_as] + self.class.traits).each do |trait|
          ivar = "@#{trait}"
          other.instance_variable_set(
            ivar,
            instance_variable_get(ivar)
          )
        end
      end

      def validation_error(err = nil)
        @validation_error = err if err
        return false if err

        @validation_error
      end

      def trait_valid?(stat)
        val = instance_variable_get("@#{stat}")
        return validation_error("#{stat} is nil") unless val ||
                                                         @allow_nil.include?(stat)

        validate = @validate_as[stat]
        if validate
          return validation_error("#{stat} is not one of #{validate}") unless
            validate.inject(false) do |ret, type|
              ret |= val.is_a? type
              ret
            end
        else
          return validation_error("#{stat} is not Numeric") unless val.is_a?(Numeric)
        end
        true
      end
    end
  end
end
