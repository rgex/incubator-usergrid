/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.usergrid.rest;


import java.util.Properties;


public class ServerEnvironmentProperties {

    public static final String API_BASE = "swagger.basepath";

    public static final String RECAPTCHA_PUBLIC = "usergrid.recaptcha.public";
    public static final String RECAPTCHA_PRIVATE = "usergrid.recaptcha.private";

    public static final String REDIRECT_ROOT = "usergrid.redirect_root";

    private Properties properties;


    public ServerEnvironmentProperties( Properties properties ) {
        this.properties = properties;
    }


    public String getProperty( String key ) {
        return properties.getProperty( key );
    }


    public String getApiBase() {
        return properties.getProperty( API_BASE );
    }


    public String getRecaptchaPublic() {
        return properties.getProperty( RECAPTCHA_PUBLIC );
    }


    public String getRecaptchaPrivate() {
        return properties.getProperty( RECAPTCHA_PRIVATE );
    }


    public String getRedirectRoot() {
        return properties.getProperty( REDIRECT_ROOT );
    }
}
