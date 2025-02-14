require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    let(:base_title) { "温泉オンライン" }

    it 'ページタイトルが提供されている時、フルタイトルを返すこと' do
      expect(helper.full_title(page_title: 'Page Title')).to eq("#{base_title} - Page Title")
    end

    it 'ページタイトルが空の時、基本タイトルだけを返すこと' do
      expect(helper.full_title(page_title: '')).to eq(base_title)
    end

    it 'ページタイトルがnilの時、基本タイトルだけを返すこと' do
      expect(helper.full_title(page_title: nil)).to eq(base_title)
    end
  end
end
