# Library

This project implements a library platform with AJAX (Asynchronous JavaScript and XML).

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
## Making the purchased books links