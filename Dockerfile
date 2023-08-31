FROM ruby:3.2.2

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Copy the Gemfile and Gemfile.lock into the container
COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Install gems
RUN bundle install

# permission to user
RUN chown -R $USER:$USER .

# Copy the rest of the application code into the container
COPY . .
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 for the Rails application
EXPOSE 3000

# Start the Rails application server
CMD ["rails", "server", "-b", "0.0.0.0"]