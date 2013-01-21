# coding: utf-8
class User < ActiveRecord::Base
  attr_accessible :provider, :uid, :name, :nickname, :image, :email, :location, :token, :secret

  has_many :plans,          :dependent => :destroy
  has_many :comments,       :dependent => :destroy
  has_many :favorites,      :dependent => :destroy
  has_many :cheers,         :dependent => :destroy
  has_many :entries,        :dependent => :destroy
  has_many :feeds,          :dependent => :destroy
  has_many :participations, :dependent => :destroy

  #-------------#
  # auth_update #
  #-------------#
  def auth_update( auth )
    if self.name != auth["info"]["name"] or self.nickname != auth["info"]["nickname"] or self.image != auth["info"]["image"] or self.email != auth["info"]["email"] or self.location != auth["info"]["location"]
      self.name     = auth["info"]["name"]
      self.nickname = auth["info"]["nickname"]
      self.image    = auth["info"]["image"]
      self.email    = auth["info"]["email"]
      self.location = auth["info"]["location"]
      self.save
    end
  end

  private

  #---------------------------#
  # self.create_with_omniauth #
  #---------------------------#
  def self.create_with_omniauth( auth )
    user = User.new
    user.provider = auth["provider"]
    user.uid      = auth["uid"]

    unless auth["info"].blank?
      user.name     = auth["info"]["name"]
      user.nickname = auth["info"]["nickname"]
      user.image    = auth["info"]["image"]
      user.email    = auth["info"]["email"]
      user.location = auth["info"]["location"]
    end

    unless auth["credentials"].blank?
      user.token  = auth['credentials']['token']
      user.secret = auth['credentials']['secret']
    end

    user.save

    return user
  end
end
