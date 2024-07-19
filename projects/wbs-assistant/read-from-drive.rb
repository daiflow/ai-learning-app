SCOPE = [
  Google::Apis::SheetsV4::AUTH_SPREADSHEETS_READONLY,
  Google::Apis::DriveV3::AUTH_DRIVE_READONLY
]
require 'google/apis/sheets_v4'
require 'google/apis/drive_v3'
require 'googleauth'

def authorize
  Google::Auth::ServiceAccountCredentials.make_creds(
    json_key_io: File.open(ENV['GOOGLE_APPLICATION_CREDENTIALS']),
    scope: SCOPE
  )
end

@sheets_service = Google::Apis::SheetsV4::SheetsService.new
@sheets_service.client_options.application_name = 'Google Sheets Reader'
@sheets_service.authorization = authorize

@drive_service = Google::Apis::DriveV3::DriveService.new
@drive_service.client_options.application_name = 'Google Drive Reader'
@drive_service.authorization = authorize

file_id = ENV['SPREADSHEET_ID']
range = 'Sheet1!A1:Z1000'

response = @drive_service.get_file(file_id, fields: 'id, name, mime_type, modified_time')


spreadsheet_id = ENV['SPREADSHEET_ID']
response = @sheets_service.get_spreadsheet(spreadsheet_id, fields: 'properties.title,properties.updatedTime,sheets.properties')
parei pq ta dando erro nao reconhecendo os campos

response = @sheets_service.get_spreadsheet(spreadsheet_id, fields: 'properties.title')


###########
# Decisao, vamos colocar para rodar de 30 em 30 minutos; se houver atualizacao em comparacao com o modified_Time do driver,
# atualizamos, enquanto ta atualizando colocamos uma flag no controler para informar q ta atualizadno. medimos o processo
# mesmo se nao tiver diferenca de modified time mas tiver passado 1 dia de diferenca de 1 dia, forcamos a atualizacao
######

def determine_export_format(mime_type)
  case mime_type
  when 'application/vnd.google-apps.document'
    'application/pdf'
  when 'application/vnd.google-apps.spreadsheet'
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  when 'application/vnd.google-apps.presentation'
    'application/vnd.openxmlformats-officedocument.presentationml.presentation'
  else
    'application/pdf'
  end
end


file = @drive_service.get_file(file_id, fields: 'name, mimeType')


destination_path = "/tmp/#{file.name}.xlsx"

@drive_service.export_file(file_id, export_mime_type, download_dest: destination_path)