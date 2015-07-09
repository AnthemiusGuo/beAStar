<?
function load_field($class,$show_name,$name,$is_must_input=FALSE)
    {
        if ($class == '')
        {
            return;
        }

        $path = '';

        // Is the model in a sub-folder? If so, parse out the filename and path.
        if (($last_slash = strrpos($class, '/')) !== FALSE)
        {
            // The path is in front of the last slash
            $path = substr($class, 0, $last_slash + 1);

            // And the model name behind it
            $model = substr($class, $last_slash + 1);
        }

        if ($name == '')
        {
            $name = $class;
        }
        $class = strtolower($class);

        $api_paths = array(FR,AR);
        foreach ($api_paths as $api_path)
        {
            if ( ! file_exists($api_path.'classes/fields/'.$path.$class.'.php'))
            {
                continue;
            }
            require_once($api_path.'classes/fields/'.$path.$class.'.php');

            $class = ucfirst($class);

            return new $class($show_name,$name,$is_must_input);
        }

        // couldn't find the model
        show_error('Unable to locate the field you have specified: '.$class);

    }
