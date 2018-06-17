module ActiveAdmin
  module Views
    class Footer < Component

      def build (namespace)
        super :id => "footer"
        super :style => "text-align: right;"

        div do
          small "Powered by the wrong number of hamsters."
        end
      end

    end
  end
end
