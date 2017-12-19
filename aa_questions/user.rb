require_relative 'question_database'

class User
  attr_accessor :fname, :lname

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM users")
    data.map { |datum| User.new(datum) }
  end

  def self.find_by_id(id)
    user = QuestionDBConnection.instance.execute(<<-SQL, id)

      SELECT
      *
      FROM
      users
      WHERE
      id = ?

    SQL

    return nil if user.empty?

    User.new(user.first)
  end

  def self.find_by_name(fname, lname)
    user = QuestionDBConnection.instance.execute(<<-SQL, fname, lname)

      SELECT
      *
      FROM
      users
      WHERE
      fname = ? AND lname = ?

    SQL

    return nil if user.empty?

    User.new(user.first)
  end

  def initialize(options)
    @id = options['id']
    @fname = options['fname']
    @lname = options['lname']
  end


end
