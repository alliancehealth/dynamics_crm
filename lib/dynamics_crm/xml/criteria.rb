module DynamicsCRM
  module XML

    class Criteria < Array
      SUPPORTED_OPERATORS = %w(And Or)

      def initialize(tuples=[], filter_operator:nil)
        filter_operator ||= 'And'
        raise "Supported operators: #{SUPPORTED_OPERATORS.join(',')}" if !SUPPORTED_OPERATORS.include?(filter_operator)

        super(tuples)
        @filter_operator = filter_operator
      end

      # ConditionExpression can be repeated multiple times
      # Operator: can be lots of values such as: eq (Equals), neq (Not Equals), gt (Greater Than)
      #           get the values from a fetch xml query
      # Values -> Value can be repeated multiple times
      # FilterOperator: and OR or depending on the filter requirements
      def to_xml(options={})
        ns = options[:namespace] ? options[:namespace] : "a"

        expressions = self.map do |tuple|
          attr_name, operator, value, data_type = *tuple
          ce = ConditionExpression.new(attr_name, operator, value, type: data_type)
          ce.to_xml(options)
        end.join('')

        %Q{<#{ns}:Criteria>
            <#{ns}:Conditions>
              #{expressions}
            </#{ns}:Conditions>
            <#{ns}:FilterOperator>#{@filter_operator}</#{ns}:FilterOperator>
        </#{ns}:Criteria>}
      end
    end
    # Criteria
  end
end
