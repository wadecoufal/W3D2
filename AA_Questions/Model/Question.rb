
class Question 
  attr_accessor :title, :body, :author_id
  attr_reader :id
  
  def initialize(options)
    @title = options['title']
    @body = options['body']
    @author_id = options['author_id']
    @id = options['id']
  end
  
  def self.find_by_id(id)
    question = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        questions 
      WHERE 
        id = ?
    SQL
    
    return nil unless question.length > 0
    Question.new(question.first)
  end
  
  def self.find_by_author_id(author_id)
    question = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM 
        questions 
      WHERE 
        author_id = ?
    SQL
    
    return nil unless question.length > 0
    Question.new(question.first)
  end
  
  def author
    author = QuestionsDatabase.instance.execute(<<-SQL, author_id)
      SELECT
        *
      FROM
        users 
      WHERE 
        id = ?
    SQL
    p author
    return nil if author.length <= 0
    User.new(author.first)
  end
  
  def replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        subject_id = ?
    SQL
    return nil if replies.empty?
    replies.map {|reply| Reply.new(reply)}
  end
    
  def followers
    QuestionFollow.followers_for_question_id(id)
  end
end