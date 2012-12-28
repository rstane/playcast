# coding: utf-8
class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :nickname, :image, :token, :secret

  has_many :plans,          :dependent => :destroy
  has_many :comments,       :dependent => :destroy
  has_many :favorites,      :dependent => :destroy
  has_many :entries,        :dependent => :destroy
  has_many :feeds,          :dependent => :destroy
  has_many :participations, :dependent => :destroy

  private

  #---------------------------#
  # self.create_with_omniauth #
  #---------------------------#
  def self.create_with_omniauth( auth )
    user = User.new
    user[:provider] = auth["provider"]
    user[:uid]      = auth["uid"]

    unless auth["info"].blank?
      user[:name]     = auth["info"]["name"]
      user[:nickname] = auth["info"]["nickname"]
      user[:image]    = auth["info"]["image"]
    end

    unless auth["credentials"].blank?
      user.token  = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end

    user.save

    return user
  end
end
