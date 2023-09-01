package main

import (
	"os"

	"github.com/gin-gonic/gin"
)

func main() {
	router := Setup()
}

func Setup() *gin.Engine {
	if err := checkFiles(); err != nil {

		os.Exit(1)
	}
	router := gin.Default()
	router.GET("/lib?=:package", sendLib)
	router.GET("/dll?=:package", sendDll)
	router.GET("/src?=:package", sendSrc)
	router.PUT("/packages?=:package", upload)
	return router
}

func checkFiles() error {
	if _, err := os.Stat("./packages"); err != nil {
		if setupErr := firstTimeSetup(); setupErr != nil {
			return setupErr
		}
	}
	return nil
}

func firstTimeSetup() error {
	if _, pkgErr := os.Create("./packages"); pkgErr != nil {
		return pkgErr
	}
	if _, libErr := os.Create("./packages/lib"); libErr != nil {
		return libErr
	}
	if _, dllErr := os.Create("./packages/dll"); dllErr != nil {
		return dllErr
	}
	if _, errErr := os.Create("./logs"); errErr != nil {
		return errErr
	}
	return nil
}
