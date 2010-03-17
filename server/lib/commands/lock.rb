module Commands
  class Lock < AbstractCommand
    def execute
      Server.instance.token = generate_token
    end

    private
    def generate_token(len=16)
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      newpass = ""
      1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
      newpass
    end
  end
end
