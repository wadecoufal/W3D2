class User 
  attr_accessor :fname, :lname
  attr_reader :id
  
  def initialize(options)
    @fname = options['fname']
    @lname = options['lname']
    @id = options['id']
  end
  
  def save
    raise "#{self} already in database." if @id
    
    QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      INSERT INTO
        users (fname, lname)
      VALUES
        (?, ?)
    SQL
    @id = QuestionsDatabase.instance.last_insert_row_id
  end
  
  def update
    raise "#{self} not in database" unless @id
    
    QuestionsDatabase.instance.execute(<<-SQL, fname, lname, id)
      UPDATE
        users 
      SET
        fname = ?, lname = ?
      WHERE
        id = ?
    SQL
    
  end
  
  def self.find_by_id(id)
    users = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        users 
      WHERE 
        id = ?
    SQL
    
    return nil unless users.length > 0
    User.new(users.first)
  end
  
  def self.find_by_name(fname, lname)
    users = QuestionsDatabase.instance.execute(<<-SQL, fname, lname)
      SELECT
        *
      FROM 
        users 
      WHERE 
        fname = ? AND lname = ?
    SQL
    
    return nil unless users.length > 0
    User.new(users.first)
  end
  
  def authored_questions
    questions = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        questions
      WHERE 
        author_id = ?
    SQL
    questions.map {|question| Question.new(question)}
  end
  
  def authored_replies
    replies = QuestionsDatabase.instance.execute(<<-SQL, id)
      SELECT
        *
      FROM 
        replies
      WHERE 
        user_id = ?
    SQL
    return nil if replies.length <= 0
    replies.map {|reply| Reply.new(reply)}
  end
  
  def followed_questions
    QuestionFollow.followed_questions_for_user_id(id)
  end
end