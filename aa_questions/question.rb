require_relative 'question_database'
require_relative 'user'
require_relative 'reply'
require_relative 'question_like'


class Question
  attr_accessor :title, :body, :author_id

  def self.all
    data = QuestionDBConnection.instance.execute("SELECT * FROM questions")
    data.map { |datum| Question.new(datum) }
  end

  def self.find_by_id(id)
    question = QuestionDBConnection.instance.execute(<<-SQL, id)

      SELECT
      *
      FROM
      questions
      WHERE
      id = ?

    SQL

    return nil if question.empty?

    Question.new(question.first)
  end

  def self.most_followed(n)
    QuestionFollow.most_followed_questions(n)
  end

  def self.find_by_author_id(author_id)
    author_questions = QuestionDBConnection.instance.execute(<<-SQL, author_id)

    SELECT
    *
    FROM
    questions
    WHERE
    author_id = ?

    SQL

    return nil if author_questions.empty?

    Question.new(author_questions.first)
  end

  def self.most_liked(n)
    QuestionLike.most_liked_questions(n)
  end

  def initialize(options)
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
  end

  def followers
    QuestionFollow.followers_for_question_id(@id)
  end

  def author
    User.find_by_id(@author_id)
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
