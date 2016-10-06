/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import XCTest
@testable import Graph

class EntitySearchTests : XCTestCase {
    var expectation: XCTestExpectation?
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testAll() {
        let graph = Graph()
        graph.clear()
        
        for i in 0..<100 {
            let n = Entity(type: "T1")
            n["P1"] = 0 == i % 2 ? "V1" : 1
            n["P2"] = "V2"
            n.add(tag: "Q1")
            n.add(to: "G1")
        }
        
        for _ in 0..<200 {
            let n = Entity(type: "T2")
            n["P2"] = "V2"
            n.add(tag: "Q2")
            n.add(to: "G2")
        }
        
        for _ in 0..<300 {
            let n = Entity(type: "T3")
            n["P3"] = "V3"
            n.add(tag: "Q3")
            n.add(to: "G3")
        }
        
        graph.sync { (success, error) in
            XCTAssertTrue(success, "\(error)")
        }
        
        let search = Search<Entity>(graph: graph)
        
        XCTAssertEqual(0, search.for(types: []).sync().count)
        XCTAssertEqual(0, search.has(tags: []).sync().count)
        XCTAssertEqual(0, search.member(of: []).sync().count)
        XCTAssertEqual(0, search.where(properties: []).sync().count)
        
        expectation = expectation(description: "[EntitySearchTests Error: Test failed.]")
        
        search.for(types: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        expectation = expectation(description: "[EntitySearchTests Error: Test failed.]")
        
        search.has(tags: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        expectation = expectation(description: "[EntitySearchTests Error: Test failed.]")
        
        search.member(of: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        expectation = expectation(description: "[EntitySearchTests Error: Test failed.]")
        
        search.where(properties: []).sync { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        expectation = expectation(description: "[EntitySearchTests Error: Test failed.]")
        
        search.for(types: []).async { [weak self] (nodes) in
            XCTAssertEqual(0, nodes.count)
            self?.expectation?.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
        
        graph.clear()
    }
}
