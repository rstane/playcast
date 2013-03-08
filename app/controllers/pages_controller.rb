# coding: utf-8
class PagesController < ApplicationController
  skip_before_filter :authorize

  #---------#
  # privacy #
  #---------#
  def privacy
  end

  #-------#
  # terms #
  #-------#
  def terms
  end

  #---------#
  # contact #
  #---------#
  def contact
  end
end
