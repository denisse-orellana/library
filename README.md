# Library

This project implements a library platform with AJAX (Asynchronous JavaScript and XML).

## Table of Contents
  * [Ruby and Rails Version](#ruby-and-rails-version)
  * [Ruby Gems](#ruby-gems)
  * [Creating the model](#creating-the-model)
  * [Making the reserved books links](#making-the-reserved-books-links)
  * [Making the purchased books links](#making-the-purchased-books-links)

## Ruby and Rails Version

* ruby '2.6.1'
* gem 'rails', '~> 5.2.6'

## Ruby Gems

```ruby
gem "devise", "~> 4.8"
gem "bootstrap", "~> 5.1"
gem "jquery-rails", "~> 4.4"
gem "faker", "~> 2.19"
```

## Creating the model

The model was defined as:

```console
rails g scaffold Book title author status:integer isbn:integer
```

With Devise gem, and following its configuration instructions, the model User is added:

```console
bundle add devise
rails generate devise:install
rails generate devise User
rails db:migrate
```

Since a User has a book, it's added from the console:

```console
rails g migration addUserToBooks user:references
```

In the models it is also added:

```ruby
class User < ApplicationRecord
  has_many :books
end
```

```ruby
class Book < ApplicationRecord
    belongs_to :user, optional: true
    enum status: [:available, :reserved, :purchased]
end
```

## Making the reserved books links

First the routes are created:

```ruby
# routes.rb

patch '/books/:id/reserve', to: 'books#reserve', as: 'reserve'
patch '/books/:id/cancel_reserve', to: 'books#cancel_reserve', as: 'cancel_reserve'
```

Then, in the controller:

```ruby
# books_controller.rb

before_action :set_book, only: %i[ show edit update destroy reserve cancel_reserve]

  def reserve
    respond_to do |format|
      if @book.update!(status: 1, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'Book was successfully reserved!'
      else
        flash.now[:notice] = 'Book could not be reserved'
      end
    end
  end

  def cancel_reserve
    respond_to do |format|
      if @book.update!(status: 0, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'The book is no longer reserved!'
      else
        flash.now[:notice] = 'The reserve could not be cancelled'
      end
    end
  end
```

## Making the purchased books links

In the routes:

```ruby
# routes.rb

patch '/books/:id/purchase', to: 'books#purchase', as: 'purchase'
patch '/books/:id/cancel_purchase', to: 'books#cancel_purchase', as: 'cancel_purchase'
```

In the controller:

```ruby
# books_controller.rb

before_action :set_book, only: %i[ show edit update destroy reserve cancel_reserve purchase cancel_purchase]

  def purchase
    respond_to do |format|
      if @book.update!(status: 2, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'The book was purchased!'
      else
        flash.now[:notice] = 'The book could not be purchased'
      end
    end
  end

  def cancel_purchase
    respond_to do |format|
      if @book.update!(status: 0, user: current_user)
        format.js { render nothing: true }
        flash.now[:notice] = 'The purchase was cancelled!'
      else
        flash.now[:notice] = 'The purchase could not be cancelled!'
      end
    end
  end
```

In the views:

```html
# books/index.html.erb

<h1>Books</h1>

<table>
  <thead>
    <tr>
      <th>Title</th>
      <th>Author</th>
      <th>Status</th>
      <th>Isbn</th>
      <th colspan="3"></th>
    </tr>
  </thead>

  <tbody id="books">
    <% @books.each do |book| %>
      <%= render 'books/book', book: book %>
    <% end %>
  </tbody>
</table>

<br>
```

And the partial *_book* is created as:

```html
# books/_book.html.erb

<tr id="book-<%= book.id %>">
    <td><%= book.title %></td>
    <td><%= book.author %></td>
    <td><%= book.status %></td>
    <td><%= book.isbn %></td>
    <div class="container">
        <td><%= link_to 'Reserve', reserve_path(book), remote: true, method: :patch, class: 'btn btn-outline-dark' %></td>
    </div>
</tr>
```

Finally, the js files update the content:

```javascript
// reserve.js.erb

$('#book-<%= @book.id %>').replaceWith('<%= j render('books/book', book: @book) %>');
```