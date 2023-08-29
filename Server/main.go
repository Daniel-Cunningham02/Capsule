package main

import "github.com/gin-gonic/gin"

func main() {
	router := Setup()
}

func Setup() *gin.Engine {
	router := gin.Default()
	router.GET("/lib?=:package", sendLib)
	router.GET("/dll?=:package", sendDll)
	router.GET("/src?=:package", sendSrc)
	router.PUT("/packages?=:package", upload)
	return router
}
