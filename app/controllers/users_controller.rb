class UsersController < ApplicationController
  def show
    @user = current_user
    @books = @user.books.reserved
    @books_purchased = @user.books.purchased
  end
end
