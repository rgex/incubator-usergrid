/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  The ASF licenses this file to You
 * under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.  For additional information regarding
 * copyright in this work, please see the NOTICE file in the top level
 * directory of this distribution.
 */
package org.apache.usergrid.persistence.collection.mvcc.stage.write;

import java.nio.ByteBuffer;
import org.apache.usergrid.persistence.model.entity.SimpleId;
import org.apache.usergrid.persistence.model.util.UUIDGenerator;
import org.junit.Assert;
import org.junit.Test;

public class EntityVersionSerializerTest {
    
    @Test
    public void testBasicOperation() {

        EntityVersion original = new EntityVersion( new SimpleId("test"), UUIDGenerator.newTimeUUID() );

        EntityVersionSerializer evs = new EntityVersionSerializer();
        ByteBuffer serialized = evs.toByteBuffer(original);

        EntityVersion deserialized = evs.fromBytes( serialized.array() );

        Assert.assertEquals( original, deserialized );
    }
}
