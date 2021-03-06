require_relative 'question_database'
require_relative 'question'
require_relative 'reply'
require_relative 'question_like'

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

  def followed_questions
    QuestionFollow.followed_questions_for_user_id(@id)
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end
end
