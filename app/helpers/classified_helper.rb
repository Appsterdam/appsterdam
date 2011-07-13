module ClassifiedHelper
  def classified_classes(classified, counter)
    classes = %w(classified grid_6 twitter-box)
    classes << (counter.odd? ? 'omega' : 'alpha')
    classes << (classified.offered? ? 'offered' : 'wanted')
    classes.join(' ')
  end
end
