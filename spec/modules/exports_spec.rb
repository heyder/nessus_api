# require_relative '../spec_helper'

# describe NessusApi::Exports do
#     before(:context) do
#         @payload = {
#           uri: 'http://ness.us',
#           username: 'username',
#           password: 'password'
#         }  
#     end
#     context ".export_status" do
#         it "successful export status" do
#             allow_any_instance_of( NessusApi::Request ).to receive( :get ).with( '/tokens/1/status').and_return( 
#                 {
#                     "folders" => [
#                         0 => {
#                             "unread_count" => 0,
#                             "custom" => 0,
#                             "default_tag" => 0,
#                             "type" => "trash",
#                             "name" => "Trash",
#                             "id" => 18
#                         }
#                     ]
#                 }.to_json
#             )
#             allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( 'mock_auth_cookie' ) )
#             allow_any_instance_of( NessusApi ).to receive(:new).and_return(  NessusApi.new( @payload ) )
      
#             nessus_api = NessusApi.new( @payload )
#             folders = Oj.load( nessus_api.list_folders )
      
#             expect( folders ).to have_key( 'folders' )
#             expect( folders["folders"]  ).to be_instance_of( Array )
#         end
#     end
#     context ".create_folder" do
#         it "successful create folder" do
#             allow_any_instance_of( NessusApi::Request ).to receive( :post ).with( '/folders',  {:name => 'mock_folder_name' }.to_json ).and_return( { id: 55 }.to_json )
#             allow( NessusApi::Session ).to receive( :create ).with( 'username' , 'password' ).and_return( NessusApi::Session.new( 'mock_auth_cookie' ) )
#             allow_any_instance_of( NessusApi ).to receive(:new).and_return(  NessusApi.new( @payload ) )
      
#             nessus_api = NessusApi.new( @payload )
#             folder = Oj.load( nessus_api.create_folder( 'mock_folder_name' ) )
      
#             expect( folder ).to have_key( 'id' )  
#             expect( folder["id"]  ).to eq( 55 )
#         end
#     end
# end