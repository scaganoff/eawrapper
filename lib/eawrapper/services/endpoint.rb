# 
#  Author::    Saul Caganoff  (mailto:scaganoff@gmail.com)
#  Copyright:: Copyright (c) 2010, Saul Caganoff
#  License::   Creative Commons Attribution 3.0 Australia License (http://creativecommons.org/licenses/by/3.0/au/)
# 
#
module EA

  # Module to represent Services in service analysis
  module Services

    # A service endpoint
    class Endpoint
      attr_accessor :component, :interface, :operation, :mep, :port, :request_message, :response_message

      # Only an external agent such as the Sequence connector can determine if this is a provider or consumer
      attr_accessor :endpoint_type

      # sequence_terminal is the terminator of the sequence connector
      # terminal_type is whether the terminal is the "start" or the "end" terminal
      def initialize(sequence_terminal, terminal_type, sequence_name)
        @terminal=sequence_terminal
        @terminal_type=terminal_type
        @sequence_name=sequence_name

        @interface=@terminal.interface
        @port=@terminal.port
        @component=@port.component

        if @terminal.is_a? ProvidedInterface then
            process_provided_interface
        end
      end

      def to_s
        if @endpoint_type==:provider then
          "#{component.name}::#{interface.name}::#{operation.name}"
        else
          "#{component.name}"
        end
      end

private

      def process_provided_interface
        # find the method description
        target_method=@sequence_name.split("(")[0]
        @operation=@interface.get_method(target_method)

        # we want to be flexible for the start endpoint - may not be connected into the correct sub-component.
        unless @operation.nil? then
          @mep=@operation.stereotype
          @message=@operation.parameters[0]
        end
      end

    end
  end
end

