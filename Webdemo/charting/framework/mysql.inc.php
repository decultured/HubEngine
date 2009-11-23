<?php

define('EZ_DRIVER_NAME', 'MySQL');
define('EZ_DRIVER_VERSION', '1.0');

class ezMySql {
	private $_server_info;
	private $_connection;
	private $_result;
	private $_num_rows;
	private $_last_query;
	private $_num_queries;
	
	public function ezMySql($server, $username, $password, $database) {
		$this->_server_info = null;
		$this->_connection = false;
		$this->_num_queries = 0;
		
		$this->Connect($server, $username, $password, $database);
	}
	
	public function Connect($server, $username, $password, $database) {
		$this->_server_info = array();
		$this->_server_info['host'] = $server;
		$this->_server_info['username'] = $username;
		$this->_server_info['password'] = $password;
		$this->_server_info['database'] = $database;
	}
	
	private function _makeConnection() {
		if($this->_server_info == null) {
			return false;
		} else if($this->_connection != false) {
			return true;
		}
		
		$this->_connection = new mysqli($this->_server_info['host'], $this->_server_info['username'], $this->_server_info['password'], $this->_server_info['database']);
		
		return $this->_connection;
	}
	
	public function Disconnect() {
		if($this->_connection == false) {
			return false;
		}
		
		$this->_connection->close();
	}
	
	public function SelectDb($database) {
		if($this->_makeConnection() == false) {
			return false;
		}
		// select the db, since we're connected.
		return $this->_connection->select_db($database);
	}
	
	public function Query($query) {
		if($this->_makeConnection() == false) {
			return false;
		}
		// close any previous result set
		if($this->_result != null) {
			// $this->_result->close();
			$this->_result = null;
		}
		
		$this->_result = $this->_connection->query($query);
		
		if(is_object($this->_result) == true) {
			$this->_num_rows = $this->_result->num_rows;
		}
		
		global $_DEBUG;
		$_DEBUG['queries_used'] += 1;
		$_DEBUG['queries_list'][] = $query;
		$this->_last_query = $query;
		return $this->_result;
	}
	
	public function Insert($query) { return $this->Query($query); }
	public function Update($query) { return $this->Query($query); }
	public function Delete($query) { return $this->Query($query); }
	
	function InsertArray($table_name, $data_array, $use_insert_ignore = false, $update_on_duplicate = false) {
		if($this->_makeConnection() == false) {
			return false;
		}
		
		$array_keys = array_keys($data_array);
		$array_values = array_values($data_array);
		
		for($i = 0; $i < count($array_values); $i++) {
			if(is_string($array_values[$i]) == true) {
				// escape this string
				$array_values[$i] = $this->EscapeData($array_values[$i]);
			} else if(is_bool($array_values[$i]) == true) {
				$array_values[$i] = (int)$array_values[$i];
			}
		}
		
		$sqlQuery = "Insert ".($use_insert_ignore == true ? "Ignore" : "")." Into {$table_name}(".implode(", ", $array_keys).") Values('".implode("', '", $array_values)."')";
		
		if($update_on_duplicate == true) {
			$fieldList = array();
			foreach($data_array as $key => $value) {
				if(is_string($value) == true) {
					// escape this string
					$fieldList[] = "{$key} = '{$this->EscapeData($value)}'";
				} else if(is_bool($value) == true) {
					$value = (int)$value;
					$fieldList[] = "{$key} = {$value}";
				} else {
					$fieldList[] = "{$key} = '{$this->EscapeData($value)}'";
				}
			}
			
			$sqlQuery .= " On Duplicate Key Update ".implode(", ", $fieldList);
		}
		
		return $this->Insert($sqlQuery);
	}
	
	function UpdateArray($table_name, $data_array, $where_clause) {
		if($this->_makeConnection() == false) {
			return false;
		}
		
		$sqlQuery = "Update {$table_name} Set ";
		
		$fieldList = array();
		foreach($data_array as $key => $value) {
			if(is_string($value) == true) {
				// escape this string
				$fieldList[] = "{$key} = '{$this->EscapeData($value)}'";
			} else if(is_bool($value) == true) {
				$value = (int)$value;
				$fieldList[] = "{$key} = {$value}";
			} else {
				$fieldList[] = "{$key} = '{$this->EscapeData($value)}'";
			}
		}
		
		$sqlQuery = "Update {$table_name} Set ".implode(", ", $fieldList);
		// do we have a where clause?
		if(is_array($where_clause) == true) {
			$whereFieldList = array();
			foreach($where_clause as $key => $value) {
				$whereFieldList[] = "{$key} = '{$value}'";
			}
			$sqlQuery .= " Where(".implode(", ", $whereFieldList).")";
		} else {
			$sqlQuery .= " Where({$where_clause})";
		}
		
		return $this->Update($sqlQuery);
	}
	
	// Note: Transactions only work on a table type of InnoDB
	function BeginTransaction() {
		if($this->_makeConnection() == false) {
			return false;
		}
		
		$this->_connection->autocommit(false);
	}
	
	function CommitTransaction() {
		$this->_connection->commit();
		$this->_connection->autocommit(true);
	}
	
	function CancelTransaction() {
		$this->_connection->rollback();
		$this->_connection->autocommit(true);
	}
	
	/*
		GetInsertId()			
			- returns the last insert id from mysql.
	*/
	function GetInsertId() {
		return $this->_connection->insert_id;
	}
	
	public function NumRows() {
		return $this->_num_rows;
	}
	
	public function MoveNext() {
		if($this->_result == false || $this->_result->num_rows == 0) {
			return null;
		}
		
		return $this->_result->fetch_assoc();
	}
	
	public function GetDataArray() {
		if($this->_result == false || $this->_result->num_rows == 0) {
			return null;
		}
		
		$this->_result->data_seek(0);
		
		$dataset = array();
		while($row = $this->_result->fetch_assoc()) {
			$dataset[] = $row;
		}
		
		return $dataset;
	}
	
	function FetchAll($sql) {
		$this->Query($sql);
		
		return $this->GetDataArray();
	}

	function FetchOne($sql) {
		$this->Query($sql);
		
		return $this->MoveNext();
	}
	
	function EscapeData($value) {
		if($this->_makeConnection() == false) {
			return false;
		}
		
		if(get_magic_quotes_gpc() == true || get_magic_quotes_runtime() == true) {
			// this data has already been escaped by the wonderful magic quotes features.
			$value = stripslashes($value);
		}
		
		return $this->_connection->real_escape_string($value);
	}
	
	function LastError() {
		$last_query = $this->LastQuery(true);
		
		return "<p>{$this->_connection->error}</p><b>SQL Query used:</b><br /><pre>{$last_query}</pre>";
	}
	
	function LastQuery($pretty_print = false) {
		if($pretty_print == false) {
			return $this->_last_query;
		} else {
			$query = $this->_last_query;
			$query = str_ireplace(" And ", "\n\tAnd ", $query);
			
			return $query;
		}
	}
}

?>
