# frozen_string_literal: true

require 'grimdark_dsl/traits'

module GrimdarkDsl
  #
  # Kill Team model
  #
  class Model
    include GrimdarkDsl::Traits

    ##### DSL for defining data

    attr_reader :Name, :Max

    traits :M, :WS, :BS, :S, :T, :W, :A, :Ld, :Sv, :Points, :Abilities
    allow_nil :Max, :Abilities
    validate_as :Abilities, Array, Symbol

    def initialize(name, parent = nil)
      @types = {}
      # rubocop:disable Naming/VariableName
      @Name = name
      @Abilities ||= []
      # rubocop:enable Naming/VariableName

      return unless parent && parent.is_a?(Model)

      parent.copy_traits(self)
    end

    def type(type_name, &block)
      model = Model.new(type_name, self)
      model.instance_eval(&block)
      @types[type_name] = model
      puts model.inspect
    end

    def subtype(type_postfix, &block)
      type("#{@Name} #{type_postfix}", &block)
    end

    def stats(hsh)
      hsh.each do |key, value|
        instance_variable_set("@#{key}", value)
      end
    end

    def max(num_or_nil = nil)
      # rubocop:disable Naming/VariableName
      @Max = num_or_nil if num_or_nil
      @Max
      # rubocop:enable Naming/VariableName
    end

    def points(num_or_nil = nil)
      # rubocop:disable Naming/VariableName
      @Points = num_or_nil if num_or_nil
      @Points
      # rubocop:enable Naming/VariableName
    end

    def ability(*abilities_to_add)
      abilities_to_add = [abilities_to_add] unless abilities_to_add.is_a? Array
      @Abilities.push(*abilities_to_add.map { |entry| entry.gsub(/\s+/, '_') }
                              .map(&:downcase)
                              .map(&:to_sym))
      @Abilities
    end

    def remove_ability(abilities_to_rm)
      abilities_to_rm = [abilities_to_rm] unless abilities_to_rm.is_a? Array
      # rubocop:disable Naming/VariableName
      @Abilities ||= []
      @Abilities -= abilities_to_rm.map { |entry| entry.gsub(/\s+/, '_') }
                                   .map(&:downcase)
                                   .map(&:to_sym)
      # rubocop:enable Naming/VariableName
      @Abilities
    end

    def append_symbols(_attribute, *_symbols)
      ability = [ability] unless ability.is_a? Array
      @Abilities.push(*ability.map { |entry| entry.gsub(/\s+/, '_') }
                              .map(&:downcase)
                              .map(&:to_sym))

      @Abilities
    end

    ##### Serialization

    def self.from_h(hsh)
      model = Model.new
      hsh.each do |key, val|
        model.instance_variable_set("@#{key}", val) if val
      end
      model.validate!
      model
    end

    def to_h
      instance_variables.each_with_object({}) do |var, hash|
        hash[var.to_s.delete('@')] = instance_variable_get(var)
      end
    end

    ##### Validation

    def valid?
      return validation_error('Name is not present') unless @Name

      # Make sure that the statline is valid
      # @copy_attributes.each do |attr|
      #   return false unless stat_valid? attr
      # end

      true
    end

    def validate!
      raise ArgumentError, validation_error unless valid?
    end
  end
end
