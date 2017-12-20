require_relative 'question_database'

class QuestionLike
  attr_accessor :user_id, :question_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM question_likes")
    data.map { |datum| QuestionLike.new(datum) }
  end

  def self.find_by_id(id)
    question_like = QuestionDBConnection.instance.execute(<<-SQL, id)

      SELECT
      *
      FROM
      question_likes
      WHERE
      id = ?

    SQL

    return nil if question_like.empty?

    QuestionLike.new(question_like.first)
  end

  def self.likers_for_question_id(question_id)

    question_likers = QuestionDBConnection.instance.execute(<<-SQL, question_id)

      SELECT
      fname, lname
      FROM
      question_likes
      JOIN
      users ON question_likes.user_id = users.id
      WHERE
      question_id = ?

    SQL

    question_likers.map{ |datum| User.new(datum)}
  end

  def self.num_likes_for_question_id(question_id)
    num_like = QuestionDBConnection.instance.execute(<<-SQL, question_id)

      SELECT
      COUNT(*) AS num
      FROM
      question_likes
      JOIN
      users ON question_likes.user_id = users.id
      WHERE
      question_id = ?

    SQL

    num_like[0]['num']
  end

  def self.liked_questions_for_user_id(user_id)

    liked_questions = QuestionDBConnection.instance.execute(<<-SQL, user_id)

      SELECT
        title, body, author_id
      FROM
        question_likes
      JOIN
        questions ON question_likes.question_id = questions.id
      WHERE
        user_id = ?
    SQL

    return nil if liked_questions.empty?

    liked_questions.map{ |datum| Question.new(datum)}
  end

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
