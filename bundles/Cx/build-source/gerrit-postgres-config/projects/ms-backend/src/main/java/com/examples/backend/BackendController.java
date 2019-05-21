/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * <p/>
 * http://www.apache.org/licenses/LICENSE-2.0
 * <p/>
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.examples.backend;


import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.InetAddress;
import java.net.UnknownHostException;


@RestController
@RequestMapping("/api")
public class BackendController {

    @RequestMapping(method = RequestMethod.GET, value = "/hellobackend", produces = "application/json")
    public void hola(HttpServletRequest req, HttpServletResponse resp) throws UnknownHostException {
        String hostname = null;

        resp.setContentType("application/json");
        ObjectMapper mapper = new ObjectMapper();
        String greeting = req.getParameter("greeting");
        ResponseDTO response = new ResponseDTO();
        response.setGreeting(greeting + " from cluster Backend");
        response.setTime(System.currentTimeMillis());
        response.setIp(getIp());

        PrintWriter out = null;
        try {
            out = resp.getWriter();
        } catch (IOException e) {
            e.printStackTrace();
        }
        try {
            mapper.writerWithDefaultPrettyPrinter().writeValue(out, response);
        } catch (IOException e) {
            e.printStackTrace();
        }

    }


    private String getIp() {
        String hostname = null;
        try {
            hostname = InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            hostname = "unknown";
        }
        return hostname;
    }


}



/** TEST WITH JETTY

public class BackendHttpServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json");

        ObjectMapper mapper = new ObjectMapper();
        String greeting = req.getParameter("greeting");

        ResponseDTO response = new ResponseDTO();
        response.setGreeting(greeting + " from cluster Backend");
        response.setTime(System.currentTimeMillis());
        response.setIp(getIp());

        PrintWriter out = resp.getWriter();
        mapper.writerWithDefaultPrettyPrinter().writeValue(out, response);
    }

    private String getIp() {
        String hostname = null;
        try {
            hostname = InetAddress.getLocalHost().getHostAddress();
        } catch (UnknownHostException e) {
            hostname = "unknown";
        }
        return hostname;
    }
}
 */





