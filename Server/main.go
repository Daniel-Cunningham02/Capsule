package main

import (
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	router := Setup()
	router.Run(":8080")
}

func Setup() *gin.Engine {
	if err := checkFiles(); err != nil {
		os.Exit(1)
	}
	router := gin.Default()
	router.GET("/lib/:package", sendLib)
	router.GET("/dll/:package", sendDll)
	router.GET("/src/:package", sendSrc)
	router.PUT("/packages/:package", upload)
	return router
}

func checkFiles() error {
	if _, err := os.Stat("./packages"); err != nil {
		firstTimeSetup()
	}
	return nil
}

func firstTimeSetup() {
	_, pkgErr := os.Create("./packages")
	checkNilError(pkgErr)
	_, libErr := os.Create("./packages/lib")
	checkNilError(libErr)
	_, dllErr := os.Create("./packages/dll")
	checkNilError(dllErr)
	_, errErr := os.Create("./logs")
	checkNilError(errErr)
}

func checkNilError(err error) {
	if err != nil {
		panic(err)
	}
}
