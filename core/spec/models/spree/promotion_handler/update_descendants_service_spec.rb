require 'spec_helper'

describe Spree::PromotionHandler::UpdateDescendantsService do
  subject { described_class.new(promotion).call }
end
