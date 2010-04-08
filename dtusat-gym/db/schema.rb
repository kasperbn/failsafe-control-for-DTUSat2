# This file is auto-generated from the current state of the database. Instead of editing this file,
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100408100411) do

  create_table "users", :force => true do |t|
    t.string 'username'
    t.string 'password'
		t.string 'latitude'
		t.string 'longitude'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "observations", :force => true do |t|
		t.string 'latitude'
		t.string 'longitude'
		t.string 'elevation'
		t.string 'azimuth'
		t.datetime 'time'
		t.boolean 'beacon_recorded'
		t.integer 'user_id'
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
		t.string 'token'
		t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "deleted_at"
  end

end
