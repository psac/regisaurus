namespace :import do
  desc 'imports master database file'
  task master: :environment do
    require 'csv'
    CSV.foreach Rails.root.join('lib', 'tasks', 'import', 'registration.txt') do |row|
      uspsa_number, first_name, last_name, female, age = row
      next if first_name == 'Walkin'

    end
  end

  desc 'imports current psac members'
  task members: :environment do
    require 'csv'
    year = Time.now.year
    CSV.foreach Rails.root.join('lib', 'tasks', 'import', 'members.csv') do |row|
      last, first, type, fee, renewed, notes, agc = row.map { |i| i.to_s }
      next if renewed.strip.blank? and notes.strip.blank? # skip any non-members

      # detect a family
      if first.include? '&'
        first.split(' & ').each do |f|
          result = Shooter.create first_name: f, last_name: last, agc_member: false, gender: 'MALE', member: year, age: 'ADULT'
          puts result.errors.full_messages.join(', ')
        end
      else
        shooter = {first_name: first, last_name: last, agc_member: false, gender: 'MALE', member: year, age: 'ADULT'}
        unless agc.strip.blank?
          shooter[:agc_member] = true
          shooter[:agc_number] = agc
        end
        result = Shooter.create shooter
        puts result.errors.full_messages.join(', ')
      end
    end
  end

  desc 'get member uspsa numbers from master....'
  task uspsa_numbers: :environment do
    require 'csv'
    ages = {'' => 'ADULT', 'Junior' => 'JUNIOR', 'Senior' => 'SENIOR', 'Super Senior' => 'SUPSNR'}
    CSV.foreach Rails.root.join('lib', 'tasks', 'import', 'registration.txt') do |row|
      uspsa, first, last, female, age = row.map { |i| i.to_s }
      shooter = Shooter.where(first_name: first, last_name: last).first
      next unless shooter
      update = {gender: female == 'Yes' ? 'FEMALE' : 'MALE', age: ages[age], uspsa_number: uspsa}
      shooter.update_attributes update
      if shooter.errors.any?
        print shooter
        puts shooter.errors.full_messages.join(', ')
      else
        puts "#{shooter} updated"
      end
    end
  end
end