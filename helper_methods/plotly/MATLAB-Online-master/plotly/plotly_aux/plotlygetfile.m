function figure = plotlygetfile(file_owner, file_id)

    [un, key, domain] = signin;

    headers = struct(...
                    'name',...
                        {...
                            'plotly-username',...
                            'plotly-apikey',...
                            'plotly-version',...
                            'plotly-platform',...
                            'user-agent'
                        },...
                    'value',...
                        {...
                            un,...
                            key,...
                            plotly_version,...
                            'MATLAB',...
                            'MATLAB'
                        });

    url = [domain, '/apigetfile/', file_owner, '/', num2str(file_id)];

    [response_string, extras] = urlread2(url, 'Post', '', headers);
    response_handler(response_string, extras);
    response_object = loadjson(response_string);
    figure = response_object.payload.figure;
end
