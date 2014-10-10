<?php
/*
mongo.config.php:数据库连接
author:
date:
*/
//conn mongo 1 as users
$mongo_flag = 0;
$mongo_conn = null;
$mongo_collections = array();
function mongo_connect(){
    global $config,$mongo_flag,$mongo_conn;
    if ($mongo_flag != 1) {
        $m = new MongoClient("mongodb://".$config['mongo']['host'].":".$config['mongo']['port'].""); // connect
        $mongo_conn = $m->selectDB($config['mongo']['db']);
        $mongo_flag = 1;
    }

    return $mongo_conn;
}
function mongoSearch($collectionName,$searchArray,$fieldArray=array()){
    global $mongo_conn,$mongo_collections;
    if (isset($mongo_collections[$collectionName])){
        $collection = $mongo_collections[$collectionName];

    } else {
        $collection = new MongoCollection($mongo_conn, $collectionName);
        $mongo_collections[$collectionName] = $collection;
    }
    
    return $collection->find($searchArray,$fieldArray);
}

function mongoSearchOne($collectionName,$searchArray,$fieldArray=array()){
    global $mongo_conn,$mongo_collections;
    if (isset($mongo_collections[$collectionName])){
        $collection = $mongo_collections[$collectionName];

    } else {
        $collection = new MongoCollection($mongo_conn, $collectionName);
        $mongo_collections[$collectionName] = $collection;
    }
    
    return $collection->findOne($searchArray,$fieldArray);
}

function mongoInsert($collectionName,$infoArray) {
    global $mongo_conn,$mongo_collections;
    if (isset($mongo_collections[$collectionName])){
        $collection = $mongo_collections[$collectionName];

    } else {
        $collection = new MongoCollection($mongo_conn, $collectionName);
        $mongo_collections[$collectionName] = $collection;
    }
    $collection->insert($infoArray);
    return $infoArray["_id"];
}

function mongoUpdate($collectionName,$where,$op){
    global $mongo_conn,$mongo_collections;
    if (isset($mongo_collections[$collectionName])){
        $collection = $mongo_collections[$collectionName];

    } else {
        $collection = new MongoCollection($mongo_conn, $collectionName);
        $mongo_collections[$collectionName] = $collection;
    }

    $collection->update($where,$op,array("upsert"=>1));
}
?>