module MailHelper
  def mail_vote_distribution(group)
    content_tag(:ul) do
      group.organization.bodies.map do |body|
        content_tag(:li) { "#{body.name}: #{group.votes_in_body(body)}" }
      end.inject(:+)
    end
  end

  def plain_mail_vote_distribution(group)
    group.organization.bodies.map do |body|
      "- #{body.name}: #{group.votes_in_body(body)}"
    end.join("\n")
  end
end
