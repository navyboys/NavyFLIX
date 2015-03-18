class ReviewDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating.present? ? "#{object.rating} / 5" : "N / A"
  end
end