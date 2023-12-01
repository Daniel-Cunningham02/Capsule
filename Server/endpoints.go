package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
	"os"
	"path/filepath"

	"github.com/gin-gonic/gin"
)

func sendLib(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/lib/", (pkg + ".lib"))
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil {
		context.String(http.StatusBadRequest, "Error occured\nStatic library not found\n")
		return
	}
	context.FileAttachment(pkgPath, (pkg + ".lib"))
	context.Status(http.StatusAccepted)
}

func sendDll(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/dll/", (pkg + ".dll"))
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil {
		context.String(http.StatusOK, "Error occured\nDynamic library not found\n")
		return
	}
	context.FileAttachment(pkgPath, (pkg + ".dll"))
}

func sendSrc(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/", pkg)
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil || fileInfo.IsDir() != true {
		context.String(http.StatusOK, "Error occured\nPackage not found\n")
		return
	}
	entries, err := os.ReadDir(pkgPath)
	if err != nil {
		context.String(http.StatusOK, "Error occured reading directory\nDirectory might not exist")
		return
	}

	var filenames []string
	var filecontents [][]byte

	for _, entry := range entries {
		filenames = append(filenames, entry.Name())
		bytes, fileErr := ioutil.ReadFile(filepath.Join(pkgPath, entry.Name()))
		fmt.Println(string(bytes))
		if fileErr != nil {
			context.String(http.StatusOK, "Error occured reading file\nFile might not exist")
			return
		}
		filecontents = append(filecontents, bytes)
	}
	// JSON is encoded. Need to find a way to decode.
	var dir = Directory{Files: &filecontents, Filenames: &filenames}
	context.JSON(http.StatusAccepted, dir)
}

func upload(context *gin.Context) {
	pkg := context.Param("package")
	pkgPath := filepath.Join("./packages/", pkg)
	fileInfo, err := os.Stat(pkgPath)
	if err != nil || fileInfo == nil {
		context.String(http.StatusOK, "Package does not exist")
		return
	}
	// Directory defined in structs.go
	var buffer []byte
	var dir *Directory

	readSize, err := context.Request.Body.Read(buffer)
	if err != nil {
		context.String(http.StatusOK, "Error Occured")
		return
	}
	jsonErr := json.Unmarshal(buffer[0:readSize], &dir)
	if jsonErr != nil {
		context.String(http.StatusOK, "Error occured parsing json")
		return
	}
	fmt.Print(dir)
}
