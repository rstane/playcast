# coding: utf-8
class FeedComment < Feed
  # コールバック
  after_create :update_sentence

  private

  # 表示文更新
  def update_sentence
    self.update_attributes( sentence: "「#{self.plan.title}」に「#{self.comment.user.name}」さんから#{self.happen}" )
  end
end
