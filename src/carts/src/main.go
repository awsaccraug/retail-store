// Copyright Amazon.com, Inc. or its affiliates. All Rights Reserved.
// SPDX-License-Identifier: MIT-0

package main

import (
	"log"
//	"net/http"
	"github.com/apex/gateway"

)

func main() {
	router := NewRouter()
	log.Fatal(gateway.ListenAndServe(":80", router))
}
