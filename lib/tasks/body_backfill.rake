namespace :data do
  namespace :backfill do
    namespace :body do
      desc 'Creates bodies for the organizations that do not have one'
        task :create, :environment do
          Organization.all.each do |org|
            org.send :create_default_body unless org.bodies.any?
          end
        end

        desc 'Associates the existing votings with the default body'
        task :assign, :environment do
          Voting.where(body_id: nil).each do |voting|
            voting.update(body_id: voting.organization.body_ids.first)
          end
        end

        desc 'Moves the existing information about votes available to the default body'
        task :groups, :environment do
          Group.all.each do |group|
            group.bodies_groups.find_by(body: group.organization.bodies.first).update(votes: group.available_votes)
          end
        end
    end
  end
end
