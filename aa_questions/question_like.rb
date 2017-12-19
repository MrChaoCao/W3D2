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

  def initialize(options)
    @id = options['id']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end
end
