require 'spec_helper'

describe 'Promotion API v2 spec', type: :request do
  include_context 'API v2 tokens'
  include_context 'Platform API v2'

  let(:bearer_token) { { 'Authorization' => valid_authorization } }

  describe 'promotion_batches#create' do
    context 'with valid params' do
      before { post '/api/v2/platform/promotion_batches', params: params, headers: bearer_token }
    
      let(:new_promotion_batch_attributes) do
        {
          template_promotion_id: nil
        }
      end

      let(:params) { { promotion_batch: new_promotion_batch_attributes } }

      it 'creates and returns a promotion batch' do
        expect(json_response['data']).to have_relationship(:template_promotion).with_data(nil)
      end
    end
  end

  describe 'promotion_batches#update' do
    context 'with valid params' do
      before { put "/api/v2/platform/promotion_batches/#{existing_promotion_batch.id}", params: params, headers: bearer_token }

      let(:existing_promotion) { create(:promotion) }
      let(:existing_promotion_batch) { create(:promotion_batch, template_promotion_id: nil) }

      let(:update_promotion_attributes) do
        {
          template_promotion_id: existing_promotion.id
        }
      end

      let(:params) { { promotion_batch: update_promotion_attributes } }

      it 'updates and returns a promotion batch' do
        expect(json_response['data']).to have_relationship(:template_promotion).with_data({ 'id' => existing_promotion.id.to_s, 'type' => 'promotion' })
      end
    end
  end
end
