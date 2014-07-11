module MatchesHelper
  def payment_button(type, amount = nil)
    if amount
      content_tag :button, class: 'btn', data: {bind: "click: $root.pay.bind($data, '#{type}', #{amount}), disable: paid || amount_due < #{amount}"} do
        "#{amount}"
      end
    else
      content_tag :button, '', class: 'btn', data: {bind: "click: $root.pay.bind($data, '#{type}', amount_due), disable: paid, text: amount_due"}
    end
  end
end
