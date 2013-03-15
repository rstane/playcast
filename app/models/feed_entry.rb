# coding: utf-8
class FeedEntry < Feed
  # コールバック
  after_create :update_sentence

  private

  # 表示文更新
  def update_sentence
    self.update_attributes( sentence: "「#{self.plan.title}」に「#{self.entry.user.name}」さんが#{self.happen}" )
  end
end
