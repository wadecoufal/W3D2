class Reply 
  attr_accessor :subject_id, :parent_reply_id, :user_id, :body
  attr_reader :id

  def initialize(options)
    @subject_id = options['subject_id']
    @parent_reply_id = options['parent_reply_id']
    @user_id = options['user_id']
    @body = options['body']
    @id = options['id']
  end
  
  def self.find_by_id(id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies 
      WHERE 
        id = ?
    SQL
    
    return nil unless replies.length > 0
    Reply.new(replies.first)
  end
  
  def self.find_by_user_id(user_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        replies 
      WHERE 
        user_id = ?
    SQL
    
    return nil unless replies.length > 0
    Reply.new(replies.first)
  end
  
  def self.find_by_question_id(subject_id)
    replies = QuestionsDatabase.instance.execute(<<-SQL, subject_id)
      SELECT
        *
      FROM 
        replies 
      WHERE 
        subject_id = ?
    SQL
    
    return nil unless replies.length > 0
    replies.map {|reply| Reply.new(reply)}
  end
  
  def author
    author = QuestionsDatabase.instance.execute(<<-SQL, user_id)
      SELECT
        *
      FROM 
        users
      WHERE 
        id = ?
    SQL
    return nil unless author.length > 0
    User.new(author.first)
  end
  
  def question
    question = QuestionsDatabase.instance.execute(<<-SQL, subject_id)
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
  
  def parent_reply
    parent_reply = QuestionsDatabase.instance.execute(<<-SQL, parent_reply_id)
      SELECT
        *
      FROM
        replies
      WHERE
        id = ?
    SQL
    
    return nil unless parent_reply.length > 0
    Reply.new(parent_reply.first)
  end
  
  def child_replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM
        replies
      WHERE
        parent_reply_id = ?
    SQL
    
    return nil unless replies.length > 0
    
    replies.map {|reply| Reply.new(reply)}
  end
  
  
end