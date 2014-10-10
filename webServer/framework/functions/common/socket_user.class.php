<?
class socket_user{
    var $socket;
    var $socket_id;
    var $player;
    var $id;
    var $uid;
    var $handshake = false;
    var $requestedResource;
    var $headers;
    var $version;
    public $handlingPartialPacket = false;
	public $partialBuffer = "";

	public $sendingContinuous = false;
	public $partialMessage = "";

	public $hasSentClose = false;
    
    
    protected $headerOriginRequired                 = false;
	protected $headerSecWebSocketProtocolRequired   = false;
	protected $headerSecWebSocketExtensionsRequired = false;
    
    private function dohandshake_v8($buffer){
        list($resource,$host,$origin,$strkey1,$strkey2,$data) = getheaders_v8($buffer);
        print("Handshaking...");
      
        $pattern = '/[^\d]*/';
        $replacement = '';
        $numkey1 = preg_replace($pattern, $replacement, $strkey1);
        $numkey2 = preg_replace($pattern, $replacement, $strkey2);
      
        $pattern = '/[^ ]*/';
        $replacement = '';
        $spaces1 = strlen(preg_replace($pattern, $replacement, $strkey1));
        $spaces2 = strlen(preg_replace($pattern, $replacement, $strkey2));
      
        if ($spaces1 == 0 || $spaces2 == 0 || $numkey1 % $spaces1 != 0 || $numkey2 % $spaces2 != 0) {
          socket_close($this->socket);
          console('failed');
          return false;
        }
      
        $ctx = hash_init('md5');
        hash_update($ctx, pack("N", $numkey1/$spaces1));
        hash_update($ctx, pack("N", $numkey2/$spaces2));
        hash_update($ctx, $data);
        $hash_data = hash_final($ctx,true);
      
        $upgrade  = "HTTP/1.1 101 WebSocket Protocol Handshake\r\n" .
                    "Upgrade: WebSocket\r\n" .
                    "Connection: Upgrade\r\n" .
                    "Sec-WebSocket-Origin: " . $origin . "\r\n" .
                    "Sec-WebSocket-Location: ws://" . $host . $resource . "\r\n" .
                    "\r\n" .
                    $hash_data;
      
        socket_write($this->socket,$upgrade.chr(0),strlen($upgrade.chr(0)));
        $this->handshake=true;
        console($upgrade);
        console("Done handshaking...");
        return true;
    }
    
    private function dohandshake_v13($buffer){
		$magicGUID = "258EAFA5-E914-47DA-95CA-C5AB0DC85B11";
		$headers = array();
		$lines = explode("\n",$buffer);
		foreach ($lines as $line) {
			if (strpos($line,":") !== false) {
				$header = explode(":",$line,2);
				$headers[strtolower(trim($header[0]))] = trim($header[1]);
			} else if (stripos($line,"get ") !== false) {
				preg_match("/GET (.*) HTTP/i", $buffer, $reqResource);
				$headers['get'] = trim($reqResource[1]);
			}
		}
		if (isset($headers['get'])) {
			$this->requestedResource = $headers['get'];
		} else {
			// todo: fail the connection
			$handshakeResponse = "HTTP/1.1 405 Method Not Allowed\r\n\r\n";			
		}
		if (!isset($headers['host']) || !$this->checkHost($headers['host'])) {
			$handshakeResponse = "HTTP/1.1 400 Bad Request";
		}
		if (!isset($headers['upgrade']) || strtolower($headers['upgrade']) != 'websocket') {
			$handshakeResponse = "HTTP/1.1 400 Bad Request";
		} 
		if (!isset($headers['connection']) || strpos(strtolower($headers['connection']), 'upgrade') === FALSE) {
			$handshakeResponse = "HTTP/1.1 400 Bad Request";
		}
		if (!isset($headers['sec-websocket-key'])) {
			$handshakeResponse = "HTTP/1.1 400 Bad Request";
		} else {

		}
		if (!isset($headers['sec-websocket-version']) || strtolower($headers['sec-websocket-version']) != 13) {
			$handshakeResponse = "HTTP/1.1 426 Upgrade Required\r\nSec-WebSocketVersion: 13";
		}
		if (($this->headerOriginRequired && !isset($headers['origin']) ) || ($this->headerOriginRequired && !$this->checkOrigin($headers['origin']))) {
			$handshakeResponse = "HTTP/1.1 403 Forbidden";
		}
		if (($this->headerSecWebSocketProtocolRequired && !isset($headers['sec-websocket-protocol'])) || ($this->headerSecWebSocketProtocolRequired && !$this->checkWebsocProtocol($header['sec-websocket-protocol']))) {
			$handshakeResponse = "HTTP/1.1 400 Bad Request";
		}
		if (($this->headerSecWebSocketExtensionsRequired && !isset($headers['sec-websocket-extensions'])) || ($this->headerSecWebSocketExtensionsRequired && !$this->checkWebsocExtensions($header['sec-websocket-extensions']))) {
			$handshakeResponse = "HTTP/1.1 400 Bad Request";
		}

		// Done verifying the _required_ headers and optionally required headers.

		if (isset($handshakeResponse)) {
			socket_write($this->socket,$handshakeResponse,strlen($handshakeResponse));
			$this->disconnect($this->socket);
			return false;
		}

		$this->headers = $headers;
		$this->handshake = $buffer;

		$webSocketKeyHash = sha1($headers['sec-websocket-key'] . $magicGUID);

		$rawToken = "";
		for ($i = 0; $i < 20; $i++) {
			$rawToken .= chr(hexdec(substr($webSocketKeyHash,$i*2, 2)));
		}
		$handshakeToken = base64_encode($rawToken) . "\r\n";

		$subProtocol = (isset($headers['sec-websocket-protocol'])) ? $this->processProtocol($headers['sec-websocket-protocol']) : "";
		$extensions = (isset($headers['sec-websocket-extensions'])) ? $this->processExtensions($headers['sec-websocket-extensions']) : "";

		$handshakeResponse = "HTTP/1.1 101 Switching Protocols\r\nUpgrade: websocket\r\nConnection: Upgrade\r\nSec-WebSocket-Accept: $handshakeToken$subProtocol$extensions\r\n";
		socket_write($this->socket,$handshakeResponse,strlen($handshakeResponse));
    }
    
    public function dohandshake($buffer){
        print("\nRequesting handshake...\n");
        $this->dohandshake_v13($buffer);
        $this->version = 13;
    }
    
    public function process($buffer){
        $data = json_decode($buffer,true);
        print "\n-----recv data-----\n";
        var_dump($data);
        print "\n------end----------\n";
    }
    
    private function unwrap_v13($buffer){
        return $buffer;
    }
    
    public function checkHost($hostName) {
		return true; // Override and return false if the host is not one that you would expect.
				     // Ex: You only want to accept hosts from the my-domain.com domain,
					 // but you receive a host from malicious-site.com instead.
	}
    public function checkOrigin($origin) {
		return true; // Override and return false if the origin is not one that you would expect.
	}

	public function checkWebsocProtocol($protocol) {
		return true; // Override and return false if a protocol is not found that you would expect.
	}

	public function checkWebsocExtensions($extensions) {
		return true; // Override and return false if an extension is not found that you would expect.
	}

	public function processProtocol($protocol) {
		return ""; // return either "Sec-WebSocket-Protocol: SelectedProtocolFromClientList\r\n" or return an empty string.  
				   // The carriage return/newline combo must appear at the end of a non-empty string, and must not
				   // appear at the beginning of the string nor in an otherwise empty string, or it will be considered part of 
				   // the response body, which will trigger an error in the client as it will not be formatted correctly.
	}

	public function processExtensions($extensions) {
		return ""; // return either "Sec-WebSocket-Extensions: SelectedExtensions\r\n" or return an empty string.
	}
    public function extractHeaders($message) {
		$header = array('fin'     => $message[0] & chr(128),
						'rsv1'    => $message[0] & chr(64),
						'rsv2'    => $message[0] & chr(32),
						'rsv3'    => $message[0] & chr(16),
						'opcode'  => ord($message[0]) & 15,
						'hasmask' => $message[1] & chr(128),
						'length'  => 0,
						'mask'    => "");
		$header['length'] = (ord($message[1]) >= 128) ? ord($message[1]) - 128 : ord($message[1]);

		if ($header['length'] == 126) {
			if ($header['hasmask']) {
				$header['mask'] = $message[4] . $message[5] . $message[6] . $message[7];
			}
			$header['length'] = ord($message[2]) * 256 
							  + ord($message[3]);
		} elseif ($header['length'] == 127) {
			if ($header['hasmask']) {
				$header['mask'] = $message[10] . $message[11] . $message[12] . $message[13];
			}
			$header['length'] = ord($message[2]) * 65536 * 65536 * 65536 * 256 
							  + ord($message[3]) * 65536 * 65536 * 65536
							  + ord($message[4]) * 65536 * 65536 * 256
							  + ord($message[5]) * 65536 * 65536
							  + ord($message[6]) * 65536 * 256
							  + ord($message[7]) * 65536 
							  + ord($message[8]) * 256
							  + ord($message[9]);
		} elseif ($header['hasmask']) {
			$header['mask'] = $message[2] . $message[3] . $message[4] . $message[5];
		}
        var_dump('----recv----',$header);
		//echo $this->strtohex($message);
		//$this->printHeaders($header);
		return $header;
	}
    
    public function frame($message, $messageType='text', $messageContinues=false) {
		switch ($messageType) {
			case 'continuous':
				$b1 = 0;
				break;
			case 'text':
				$b1 = ($this->sendingContinuous) ? 0 : 1;
				break;
			case 'binary':
				$b1 = ($this->sendingContinuous) ? 0 : 2;
				break;
			case 'close':
				$b1 = 8;
				break;
			case 'ping':
				$b1 = 9;
				break;
			case 'pong':
				$b1 = 10;
				break;
		}
		if ($messageContinues) {
			$this->sendingContinuous = true;
		} else {
			$b1 += 128;
			$this->sendingContinuous = false;
		}

		$length = strlen($message);
		$lengthField = "";
		if ($length < 126) {
			$b2 = $length;
		} elseif ($length <= 65536) {
			$b2 = 126;
			$hexLength = dechex($length);
			//$this->stdout("Hex Length: $hexLength");
			if (strlen($hexLength)%2 == 1) {
				$hexLength = '0' . $hexLength;
			} 
			$n = strlen($hexLength) - 2;

			for ($i = $n; $i >= 0; $i=$i-2) {
				$lengthField = chr(hexdec(substr($hexLength, $i, 2))) . $lengthField;
			}
			while (strlen($lengthField) < 2) {
				$lengthField = chr(0) . $lengthField;
			}
		} else {
			$b2 = 127;
			$hexLength = dechex($length);
			if (strlen($hexLength)%2 == 1) {
				$hexLength = '0' . $hexLength;
			} 
			$n = strlen($hexLength) - 2;

			for ($i = $n; $i >= 0; $i=$i-2) {
				$lengthField = chr(hexdec(substr($hexLength, $i, 2))) . $lengthField;
			}
			while (strlen($lengthField) < 8) {
				$lengthField = chr(0) . $lengthField;
			}
		}

		return chr($b1) . chr($b2) . $lengthField . $message;
	}

	public function deframe($message) {
		//echo $this->strtohex($message);
		$headers = $this->extractHeaders($message);
		$pongReply = false;
		$willClose = false;
        
		switch($headers['opcode']) {
			case 0:
			case 1:
			case 2:
				break;
			case 8:
				// todo: close the connection
				$this->hasSentClose = true;
				return "";
			case 9:
				$pongReply = true;
			case 10:
				break;
			default:
				//$this->disconnect($this); // todo: fail connection
				$willClose = true;
				break;
		}

		if ($this->handlingPartialPacket) {
			$message = $this->partialBuffer . $message;
			$this->handlingPartialPacket = false;
			return $this->deframe($message);
		}

		if ($this->checkRSVBits($headers,$this)) {
			return false;
		}

		if ($willClose) {
			// todo: fail the connection
			return false;
		}

		$payload = $this->partialMessage . $this->extractPayload($message,$headers);

		if ($pongReply) {
			$reply = $this->frame($payload,$this,'pong');
			socket_write($this->socket,$reply,strlen($reply));
			return false;
		}
		if (extension_loaded('mbstring')) {
			if ($headers['length'] > mb_strlen($payload)) {
				$this->handlingPartialPacket = true;
				$this->partialBuffer = $message;
				return false;
			}
		} else {
			if ($headers['length'] > strlen($payload)) {
				$this->handlingPartialPacket = true;
				$this->partialBuffer = $message;
				return false;
			}
		}

		$payload = $this->applyMask($headers,$payload);

		if ($headers['fin']) {
			$this->partialMessage = "";
			return $payload;
		}
		$this->partialMessage = $payload;
		return false;
	}
    protected function extractPayload($message,$headers) {
		$offset = 2;
		if ($headers['hasmask']) {
			$offset += 4;
		}
		if ($headers['length'] > 65535) {
			$offset += 8;
		} elseif ($headers['length'] > 125) {
			$offset += 2;
		}
		return substr($message,$offset);
	}

	protected function applyMask($headers,$payload) {
		$effectiveMask = "";
		if ($headers['hasmask']) {
			$mask = $headers['mask'];
		} else {
			return $payload;
		}

		while (strlen($effectiveMask) < strlen($payload)) {
			$effectiveMask .= $mask;
		}
		while (strlen($effectiveMask) > strlen($payload)) {
			$effectiveMask = substr($effectiveMask,0,-1);
		}
		return $effectiveMask ^ $payload;
	}
	protected function checkRSVBits($headers,$user) { // override this method if you are using an extension where the RSV bits are used.
		if (ord($headers['rsv1']) + ord($headers['rsv2']) + ord($headers['rsv3']) > 0) {
			//$this->disconnect($user); // todo: fail connection
			return true;
		}
		return false;
	}

	protected function strtohex($str) {
		$strout = "";
		for ($i = 0; $i < strlen($str); $i++) {
			$strout .= (ord($str[$i])<16) ? "0" . dechex(ord($str[$i])) : dechex(ord($str[$i]));
			$strout .= " ";
			if ($i%32 == 7) {
				$strout .= ": ";
			}
			if ($i%32 == 15) {
				$strout .= ": ";
			}
			if ($i%32 == 23) {
				$strout .= ": ";
			}
			if ($i%32 == 31) {
				$strout .= "\n";
			}
		}
		return $strout . "\n";
	}

	protected function printHeaders($headers) {
		echo "Array\n(\n";
		foreach ($headers as $key => $value) {
			if ($key == 'length' || $key == 'opcode') {
				echo "\t[$key] => $value\n\n";
			} else {
				echo "\t[$key] => ".$this->strtohex($value)."\n";

			}

		}
		echo ")\n";
	}
}

?>